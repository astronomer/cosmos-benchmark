{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02162') }},
        {{ ref('model_02046') }},
        {{ ref('model_02231') }}
)
select id, 'model_02332' as name from sources
