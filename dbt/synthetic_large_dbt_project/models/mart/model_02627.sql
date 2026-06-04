{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01702') }},
        {{ ref('model_02223') }}
)
select id, 'model_02627' as name from sources
