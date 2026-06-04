{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02248') }},
        {{ ref('model_01764') }},
        {{ ref('model_01673') }}
)
select id, 'model_02839' as name from sources
