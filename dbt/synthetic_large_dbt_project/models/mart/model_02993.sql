{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01930') }},
        {{ ref('model_02139') }},
        {{ ref('model_02086') }}
)
select id, 'model_02993' as name from sources
