{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01775') }},
        {{ ref('model_01592') }},
        {{ ref('model_02025') }}
)
select id, 'model_02261' as name from sources
