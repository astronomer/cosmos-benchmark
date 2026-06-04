{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01834') }},
        {{ ref('model_01789') }}
)
select id, 'model_02278' as name from sources
