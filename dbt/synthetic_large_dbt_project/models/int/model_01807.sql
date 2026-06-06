{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00879') }},
        {{ ref('model_00896') }},
        {{ ref('model_01137') }}
)
select id, 'model_01807' as name from sources
