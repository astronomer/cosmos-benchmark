{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01634') }},
        {{ ref('model_01887') }},
        {{ ref('model_02121') }}
)
select id, 'model_02315' as name from sources
