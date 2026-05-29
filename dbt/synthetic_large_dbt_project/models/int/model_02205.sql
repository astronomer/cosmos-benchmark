{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00775') }},
        {{ ref('model_01156') }},
        {{ ref('model_00987') }}
)
select id, 'model_02205' as name from sources
