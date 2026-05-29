{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02062') }},
        {{ ref('model_01784') }}
)
select id, 'model_02606' as name from sources
