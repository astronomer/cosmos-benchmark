{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01516') }},
        {{ ref('model_02013') }}
)
select id, 'model_02835' as name from sources
