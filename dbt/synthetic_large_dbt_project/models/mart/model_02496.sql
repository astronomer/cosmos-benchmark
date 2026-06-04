{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02201') }},
        {{ ref('model_01896') }},
        {{ ref('model_01917') }}
)
select id, 'model_02496' as name from sources
