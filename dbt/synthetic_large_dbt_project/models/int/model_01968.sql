{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01141') }},
        {{ ref('model_00775') }},
        {{ ref('model_00883') }}
)
select id, 'model_01968' as name from sources
