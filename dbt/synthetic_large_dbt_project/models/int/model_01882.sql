{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00794') }}
)
select id, 'model_01882' as name from sources
