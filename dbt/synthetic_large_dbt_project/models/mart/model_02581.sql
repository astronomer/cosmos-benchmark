{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01697') }},
        {{ ref('model_02000') }},
        {{ ref('model_01788') }}
)
select id, 'model_02581' as name from sources
