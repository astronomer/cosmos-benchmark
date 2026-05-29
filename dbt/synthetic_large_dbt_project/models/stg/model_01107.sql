{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00000') }},
        {{ ref('model_00743') }}
)
select id, 'model_01107' as name from sources
